using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Encore : Ability
    {
        public Encore()
        {
            Name = "Encore";
            FlavorText = "The crowd goes wild! Increases an ally's attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
