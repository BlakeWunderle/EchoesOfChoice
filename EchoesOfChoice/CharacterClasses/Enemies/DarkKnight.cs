using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class DarkKnight : BaseFighter
    {
        public DarkKnight(int level = 16)
        {
            Level = level;
            Health = Stat(300, 340, 8, 12, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(48, 56, 3, 5, 16);
            PhysicalDefense = Stat(34, 40, 3, 4, 16);
            MagicAttack = Stat(28, 34, 2, 3, 16);
            MagicDefense = Stat(28, 34, 2, 3, 16);
            Speed = Stat(30, 36, 2, 3, 16);
            Abilities = new List<Ability>() { new DarkBlade(), new ShadowGuard(), new Cleave() };
            CharacterType = "Dark Knight";
            Mana = Stat(24, 30, 2, 4, 16);
            MaxMana = Mana;
            CritChance = 25;
            CritDamage = 5;
            DodgeChance = 15;
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
