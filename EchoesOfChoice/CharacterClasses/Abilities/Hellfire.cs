using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Hellfire : Ability
    {
        public Hellfire()
        {
            Name = "Hellfire";
            FlavorText = "Unholy flames erupt from below, consuming the enemy in infernal fire.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 11;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
        }
    }
}
