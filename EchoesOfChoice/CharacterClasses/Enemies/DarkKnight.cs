using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class DarkKnight : BaseFighter
    {
        public DarkKnight(int level = 18)
        {
            Level = level;
            Health = Stat(358, 398, 8, 12, 18);
            MaxHealth = Health;
            PhysicalAttack = Stat(64, 72, 4, 6, 18);
            PhysicalDefense = Stat(40, 48, 3, 5, 18);
            MagicAttack = Stat(34, 42, 2, 4, 18);
            MagicDefense = Stat(34, 42, 2, 4, 18);
            Speed = Stat(34, 40, 2, 4, 18);
            Abilities = new List<Ability>() { new DarkBlade(), new ShadowGuard(), new Cleave() };
            CharacterType = "Dark Knight";
            Mana = Stat(30, 38, 3, 5, 18);
            MaxMana = Mana;
            CritChance = 26;
            CritDamage = 5;
            DodgeChance = 19;
        }

        public DarkKnight(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new DarkKnight(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
