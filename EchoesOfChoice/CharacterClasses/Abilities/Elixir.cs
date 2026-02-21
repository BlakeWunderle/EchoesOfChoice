using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Elixir : Ability
    {
        public Elixir()
        {
            Name = "Elixir";
            FlavorText = "Administer a carefully brewed healing potion. Restores health.";
            ModifiedStat = StatEnum.Health;
            Modifier = 12;
            impactedTurns = 0;
            UseOnEnemy = false;
            ManaCost = 5;
        }
    }
}
