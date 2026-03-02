using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Lich : BaseFighter
    {
        public Lich(int level = 16)
        {
            Level = level;
            Health = Stat(290, 330, 8, 12, 16);
            MaxHealth = Health;
            PhysicalAttack = Stat(14, 18, 0, 2, 16);
            PhysicalDefense = Stat(24, 30, 2, 3, 16);
            MagicAttack = Stat(57, 65, 4, 6, 16);
            MagicDefense = Stat(42, 50, 3, 5, 16);
            Speed = Stat(34, 40, 2, 4, 16);
            Abilities = new List<Ability>() { new DeathBolt(), new RaiseDead(), new SoulCage() };
            CharacterType = "Lich";
            Mana = Stat(44, 52, 3, 5, 16);
            MaxMana = Mana;
            CritChance = 23;
            CritDamage = 5;
            DodgeChance = 18;
        }

        public Lich(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Lich(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(2, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
