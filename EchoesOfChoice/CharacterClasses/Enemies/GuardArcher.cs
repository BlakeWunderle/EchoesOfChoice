using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class GuardArcher : BaseFighter
    {
        public GuardArcher(int level = 12)
        {
            Level = level;
            Health = Stat(178, 208, 6, 10, 12);
            MaxHealth = Health;
            PhysicalAttack = Stat(43, 51, 3, 5, 12);
            PhysicalDefense = Stat(18, 24, 1, 3, 12);
            MagicAttack = Stat(6, 10, 0, 2, 12);
            MagicDefense = Stat(18, 24, 1, 3, 12);
            Speed = Stat(32, 38, 3, 4, 12);
            Abilities = new List<Ability>() { new ArrowShot(), new Volley(), new PinDown() };
            CharacterType = "Guard Archer";
            Mana = Stat(18, 24, 2, 4, 12);
            MaxMana = Mana;
            CritChance = 25;
            CritDamage = 4;
            DodgeChance = 20;
        }

        public GuardArcher(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new GuardArcher(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 6);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(0, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
